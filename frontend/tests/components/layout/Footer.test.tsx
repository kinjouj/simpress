import { act, render } from '@testing-library/react';
import Footer from '../../../src/components/layout/Footer';

describe('Footer', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.clearAllTimers();
  });

  test('<Footer> test', () => {
    const { container } = render(<Footer />);
    act(() => {
      jest.runAllTimers();
    });

    expect(container.innerHTML).not.toBeNull();
  });
});
