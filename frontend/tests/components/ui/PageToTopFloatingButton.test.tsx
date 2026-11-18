import { render, screen } from '@testing-library/react';
import { userEvent } from '@testing-library/user-event';
import PageToTopFloatingButton from '../../../src/components/ui/PageToTopFloatingButton';

describe('PageToTopFloatingButton', () => {
  it('scrolls smoothly to top', async () => {
    const scrollTo = vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
    render(<PageToTopFloatingButton />);

    const user = userEvent.setup();
    const button = screen.getByRole('button', { name: 'page to top' });
    await user.click(button);
    expect(scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });
});
