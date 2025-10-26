import { render } from '@testing-library/react';
import Header from '../../../src/components/layout/Header';

describe('Header', () => {
  test('<Header> test', () => {
    const { container } = render(<Header />);
    expect(container.innerHTML).not.toBeNull();
  });
});
