import { renderHook, act } from '@testing-library/react';
import React from 'react';
import { GameProvider, useGame } from './GameContext';

// provide a minimal localStorage stub for node tests
beforeAll(() => {
  global.localStorage = {
    getItem: vi.fn(),
    setItem: vi.fn(),
    removeItem: vi.fn(),
  } as unknown as Storage;
});

describe('GameContext', () => {
  it('simulateTicks increments tickCount by requested amount', () => {
    const wrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => (
      <GameProvider>{children}</GameProvider>
    );

    const { result } = renderHook(() => useGame(), { wrapper });
    expect(result.current.tickCount).toBe(0);

    act(() => {
      result.current.simulateTicks(5);
    });

    expect(result.current.tickCount).toBe(5);
  });

  it('toggleTech unlocks tech and boosts immigration', () => {
    const wrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => (
      <GameProvider>{children}</GameProvider>
    );
    const { result } = renderHook(() => useGame(), { wrapper });

    // initial population
    const initialPeople = result.current.gameState.people;

    // manual immigration without tech
    act(() => {
      result.current.manualImmigration();
    });
    const afterNoTech = result.current.gameState.people;
    expect(afterNoTech).toBeGreaterThan(initialPeople);

    // reset and add tech
    act(() => {
      result.current.resetGame();
      result.current.toggleTech('advancedAgriculture');
    });

    const baseline = result.current.gameState.people;
    act(() => {
      result.current.manualImmigration();
    });
    const afterWithTech = result.current.gameState.people;

    expect(afterWithTech - baseline).toBeGreaterThan(afterNoTech - initialPeople);
  });
});
