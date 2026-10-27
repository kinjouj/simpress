import { render } from '@testing-library/react';
import Footer from '../../../src/components/layout/Footer';

describe('Footer', () => {
  it('フッターを表示する', () => {
    const { container } = render(<Footer />);
    expect(container.innerHTML).not.toBeNull();
  });
});
