import { render, screen } from '@testing-library/react';
import { userEvent } from '@testing-library/user-event';
import PageToTopFloatingButton from '../../../src/components/ui/PageToTopFloatingButton';

const mockScrollTo = vi.fn();
window.scrollTo = mockScrollTo;

describe('PageToTopFloatingButton', () => {
  it('クリックでページ最上部へスムーズにスクロールする', async () => {
    render(<PageToTopFloatingButton />);
    const user = userEvent.setup();
    const button = screen.getByRole('button', { name: 'page to top' });
    await user.click(button);
    expect(mockScrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });
});
