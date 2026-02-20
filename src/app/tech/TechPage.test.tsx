import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';

vi.mock('../../components/TechTree', () => ({ default: () => <div>techtree</div> }));

import TechPage from './page';

describe('TechPage', () => {
  it('renders TechTree component', () => {
    render(<TechPage />);
    expect(screen.getByText('techtree')).toBeInTheDocument();
  });
});
