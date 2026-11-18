import { render, screen } from '@testing-library/react';
import Footer from '../../../src/components/layout/Footer';

describe('Footer', () => {
  it('shows the footer', () => {
    render(<Footer />);

    expect(screen.getByRole('contentinfo')).toHaveTextContent('Powered by simpress');
  });
});
