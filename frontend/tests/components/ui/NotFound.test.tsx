import { render, screen } from '@testing-library/react';
import NotFound from '../../../src/components/ui/NotFound';

describe('NotFound', () => {
  it('shows Not Found', () => {
    render(<NotFound />);

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });
});
