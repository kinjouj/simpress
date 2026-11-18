import { render, screen } from '@testing-library/react';
import Header from '../../../src/components/layout/Header';

describe('Header', () => {
  it('shows the header', () => {
    render(<Header />);

    expect(screen.getByRole('banner')).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'frontend test' })).toHaveAttribute('href', '/');
    expect(screen.getByRole('button', { name: 'Search' })).toBeInTheDocument();
  });
});
