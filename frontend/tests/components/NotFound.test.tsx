import { render } from '@testing-library/react';
import NotFound from '../../src/components/NotFound';

describe('NotFound', () => {
  test('<NotFound /> rendering test', () => {
    const { container } = render(<NotFound />);
    expect(container.innerHTML).not.toBeNull();
  });
});
