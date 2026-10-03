import { render, screen } from '@testing-library/react';
import NotFound from '../../../src/components/ui/NotFound';

describe('NotFound', () => {
  it('Not Foundを表示する', () => {
    render(<NotFound />);
    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });
});
