import { render } from '@testing-library/react';
import Header from '../../../src/components/layout/Header';

describe('Header', () => {
  it('ヘッダーを表示する', () => {
    const { container } = render(<Header />);
    expect(container.innerHTML).not.toBeNull();
  });
});
