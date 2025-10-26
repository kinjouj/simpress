import { render, screen } from '@testing-library/react';
import NotFound from '../../../src/components/ui/NotFound';

describe('NotFound', () => {
  test('<NotFound /> test', () => {
    render(<NotFound />);
    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });
});
