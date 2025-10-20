import { render } from '@testing-library/react';
import Header from '../../src/components/Header';

describe('Header', () => {
  test('<Header> rendering test', () => {
    const { container } = render(<Header />);
    expect(container.innerHTML).not.toBeNull();
  });
});
