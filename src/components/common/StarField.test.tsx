import React from 'react';
import { render } from '@testing-library/react';
import '@testing-library/jest-dom';
import StarField from './StarField';
import { Territory, TerritoryType, EventType, EventCategory } from '../../models/types';

// JSDOM stubs for canvas (no actual drawing)
HTMLCanvasElement.prototype.getContext = () => null;

const makeTerritory = (type: TerritoryType = TerritoryType.rural): Territory => ({
  id: Math.random().toString(36).slice(2),
  name: 'Test Territory',
  description: 'desc',
  type,
  population: 100,
  capacity: 1000,
  isUnlocked: true,
});

const baseProps = {
  population: 1000,
  territories: [makeTerritory()],
  tickCount: 0,
  latestEvent: null,
};

describe('StarField', () => {
  it('renders a canvas element', () => {
    const { container } = render(<StarField {...baseProps} />);
    const canvas = container.querySelector('canvas');
    expect(canvas).toBeInTheDocument();
  });

  it('is not aria-hidden (screen readers can announce it)', () => {
    const { container } = render(<StarField {...baseProps} />);
    const canvas = container.querySelector('canvas');
    expect(canvas?.getAttribute('aria-hidden')).toBe('false');
  });

  it('has an aria-label containing population and territory count', () => {
    const { container } = render(<StarField {...baseProps} />);
    const canvas = container.querySelector('canvas');
    const label = canvas?.getAttribute('aria-label') ?? '';
    expect(label).toMatch(/population/i);
    expect(label).toMatch(/territories/i);
  });

  it('does not throw with zero population', () => {
    expect(() =>
      render(<StarField {...baseProps} population={0} territories={[]} />),
    ).not.toThrow();
  });

  it('does not throw with null latestEvent', () => {
    expect(() => render(<StarField {...baseProps} latestEvent={null} />)).not.toThrow();
  });

  it('does not throw with a disaster event', () => {
    expect(() =>
      render(
        <StarField
          {...baseProps}
          latestEvent={{
            id: 'e1',
            title: 'Disaster',
            description: 'desc',
            type: EventType.disaster,
            populationChange: -50,
            timestamp: Date.now(),
            category: EventCategory.disaster,
          }}
        />,
      ),
    ).not.toThrow();
  });

  it('does not throw with space territories', () => {
    expect(() =>
      render(
        <StarField
          {...baseProps}
          territories={[
            makeTerritory(TerritoryType.spaceStation),
            makeTerritory(TerritoryType.orbital),
            makeTerritory(TerritoryType.interstellar),
          ]}
        />,
      ),
    ).not.toThrow();
  });

  it('renders role="img" on the canvas', () => {
    const { container } = render(<StarField {...baseProps} />);
    const canvas = container.querySelector('canvas');
    expect(canvas?.getAttribute('role')).toBe('img');
  });
});
