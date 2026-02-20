/* eslint-disable no-console */
'use client';

import React, { createContext, useContext, useEffect, useState, useCallback } from 'react';
import { GameState, createInitialGameState, GameEvent, Territory } from '../models/types';
import { getAvailableConfigs } from '../models/territoryConfig';
import { generateEventForTerritory, checkMilestoneEvent } from '../services/eventSystem';
import StorageModal from '../components/StorageModal';

interface GameContextType {
  gameState: GameState;
  manualImmigration: () => void;
  resetGame: () => void;
  openStorageSettings: () => void;
}

const GameContext = createContext<GameContextType | undefined>(undefined);

// storage key used for local saves; name expanded for clarity
// if we add cloud saving the same identifier would be handled by the server
const STORAGE_KEY = 'immigrants_game_save';

// track whether player chose local or cloud persistence; `null` means prompt not answered yet

export const GameProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [gameState, setGameState] = useState<GameState>(createInitialGameState());
  const [isLoaded, setIsLoaded] = useState(false);

  // Determine where to store game: cloud vs local.  a real cloud
  // option would involve an auth/login flow and API calls; here we
  // simply ask once via confirm and use a flag for the rest of the
  // session.  null indicates the user hasn't chosen yet.
  const [useCloud, setUseCloud] = useState<boolean | null>(null);
  const [showStorageModal, setShowStorageModal] = useState(false);

  useEffect(() => {
    if (useCloud === null) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setShowStorageModal(true);
    }
  }, [useCloud]);

  // Load game after choice has been made (or immediately for local)
  useEffect(() => {
    if (useCloud) {
      // TODO: fetch from server once auth is available
      console.log('cloud save selected - loading not implemented');
    } else if (useCloud === false || useCloud === null) {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        try {
          const parsed = JSON.parse(saved);
          // eslint-disable-next-line react-hooks/set-state-in-effect
          setGameState({
            ...createInitialGameState(),
            ...parsed,
            lastSave: Date.now(),
          });
        } catch (e) {
          console.error('Failed to load game save', e);
        }
      }
    }
    setIsLoaded(true);
  }, [useCloud]);

  // Save game on interval to whichever storage was chosen
  useEffect(() => {
    if (!isLoaded) {
      return;
    }
    const saveInterval = setInterval(() => {
      setGameState((prev) => {
        const updated = { ...prev, lastSave: Date.now() };
        if (useCloud) {
          // TODO: POST to server API
          console.log('would send save to cloud', updated);
        } else {
          localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));
        }
        return updated;
      });
    }, 10000);
    return () => clearInterval(saveInterval);
  }, [isLoaded, useCloud]);

  const processEvent = useCallback((state: GameState, event: GameEvent): GameState => {
    const newState = { ...state };
    newState.eventHistory = [event, ...newState.eventHistory].slice(0, 50); // Keep last 50

    if (event.targetTerritoryId) {
      const tIndex = newState.territories.findIndex((t) => t.id === event.targetTerritoryId);
      if (tIndex >= 0) {
        const territory = { ...newState.territories[tIndex] };
        territory.population = Math.max(
          0,
          Math.min(territory.capacity, territory.population + event.populationChange),
        );
        newState.territories = [...newState.territories];
        newState.territories[tIndex] = territory;
      }
    } else {
      newState.people = Math.max(0, newState.people + event.populationChange);
    }

    if (event.populationChange > 0) {
      newState.totalImmigrants += Math.floor(event.populationChange);
    }

    return newState;
  }, []);

  // Core Game Loop
  useEffect(() => {
    if (!isLoaded) {
      return;
    }

    // Tick every 1 second
    const gameTimer = setInterval(() => {
      setGameState((prev) => {
        let newState = { ...prev, playTime: prev.playTime + prev.gameSpeed };
        const currentTotalPop = newState.territories.reduce((sum, t) => sum + t.population, 0);

        // Check locks
        const availableConfigs = getAvailableConfigs(currentTotalPop);
        for (const config of availableConfigs) {
          if (!newState.territories.find((t) => t.id === config.id)) {
            const newTerritory: Territory = {
              id: config.id,
              name: config.nameKey,
              description: config.descriptionKey,
              type: config.type,
              capacity:
                config.threshold * config.capacityMultiplier * config.capacityBaseMultiplier,
              population: 0,
              isUnlocked: true,
            };
            newState.territories = [...newState.territories, newTerritory];

            const unlockEvent: GameEvent = {
              id: `unlock_${config.id}_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`,
              title: 'Territory Unlocked',
              description: `New territory available: ${config.nameKey}`,
              // eslint-disable-next-line @typescript-eslint/no-explicit-any
              type: 'milestone' as any,
              populationChange: 0,
              targetTerritoryId: config.id,
              timestamp: Date.now(),
              category: 'milestone',
            };
            newState = processEvent(newState, unlockEvent);
          }
        }

        return newState;
      });
    }, 1000);

    // Event Loop every 5 seconds
    const eventTimer = setInterval(() => {
      setGameState((prev) => {
        let newState = { ...prev };
        const currentTotalPop = newState.territories.reduce((sum, t) => sum + t.population, 0);

        // Check milestones
        const milestoneEvent = checkMilestoneEvent(currentTotalPop, newState.achievedMilestones);
        if (milestoneEvent) {
          newState = processEvent(newState, milestoneEvent);
          if (!newState.achievedMilestones.includes(milestoneEvent.id)) {
            newState.achievedMilestones = [...newState.achievedMilestones, milestoneEvent.id];
          }
        }

        // Territory events
        for (const territory of newState.territories) {
          if (territory.isUnlocked) {
            const event = generateEventForTerritory(territory);
            if (event) {
              newState = processEvent(newState, event);
            }
          }
        }
        return newState;
      });
    }, 5000);

    return () => {
      clearInterval(gameTimer);
      clearInterval(eventTimer);
    };
  }, [isLoaded, processEvent]);

  const manualImmigration = useCallback(() => {
    setGameState((prev) => {
      const available =
        prev.territories.find((t) => t.isUnlocked && t.population < t.capacity) ||
        prev.territories[0];
      const currentPop = prev.territories.reduce((sum, t) => sum + t.population, 0);
      const amount = Math.max(1, Math.min(1000000, Math.ceil(currentPop * 0.01)));

      const manualEvent: GameEvent = {
        id: `manual_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`,
        title: 'Manual Immigration',
        description: `You helped ${amount} new immigrants settle in ${available.name}`,
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        type: 'immigration' as any,
        populationChange: amount,
        targetTerritoryId: available.id,
        timestamp: Date.now(),
        category: 'opportunity',
      };

      return processEvent(prev, manualEvent);
    });
  }, [processEvent]);

  const resetGame = useCallback(() => {
    setGameState(createInitialGameState());
    if (useCloud) {
      // TODO: delete cloud save
      console.log('cloud save deleted');
    } else {
      localStorage.removeItem(STORAGE_KEY);
    }
  }, [useCloud]);

  const openStorageSettings = useCallback(() => {
    setShowStorageModal(true);
  }, []);

  return (
    <GameContext.Provider value={{ gameState, manualImmigration, resetGame, openStorageSettings }}>
      {children}
      <StorageModal
        isOpen={showStorageModal}
        onClose={() => setShowStorageModal(false)}
        canClose={useCloud !== null}
        onSelectLocal={() => {
          setUseCloud(false);
          setShowStorageModal(false);
        }}
        onSelectCloud={() => {
          setUseCloud(true);
          setShowStorageModal(false);
        }}
        onReset={() => {
          if (
            window.confirm(
              'Are you absolutely sure you want to reset all game data? This cannot be undone.',
            )
          ) {
            resetGame();
            setShowStorageModal(false);
          }
        }}
      />
    </GameContext.Provider>
  );
};

export const useGame = () => {
  const context = useContext(GameContext);
  if (context === undefined) {
    throw new Error('useGame must be used within a GameProvider');
  }
  return context;
};
