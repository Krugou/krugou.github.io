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
});
