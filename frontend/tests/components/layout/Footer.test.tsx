import { render } from '@testing-library/react';
import Footer from '../../../src/components/layout/Footer';

describe('Footer', () => {
  test('<Footer> test', () => {
    const { container } = render(<Footer />);
    expect(container.innerHTML).not.toBeNull();
  });
});
