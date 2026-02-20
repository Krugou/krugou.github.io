import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';

vi.mock('react-i18next', () => ({ useTranslation: () => ({ t: (k: string) => k }) }));

import TechTree from './TechTree';

describe('TechTree', () => {
  it('shows placeholder content', () => {
    render(<TechTree />);
    expect(screen.getByText('ui.techTree')).toBeInTheDocument();
    expect(screen.getByText('ui.techTreePlaceholder')).toBeInTheDocument();
    expect(screen.getByText('ui.techTreeComingSoon')).toBeInTheDocument();
  });
});
