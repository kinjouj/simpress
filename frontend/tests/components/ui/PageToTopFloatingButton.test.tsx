import { render, screen } from '@testing-library/react';
import { userEvent } from '@testing-library/user-event';
import PageToTopFloatingButton from '../../../src/components/ui/PageToTopFloatingButton';

const mockScrollTo = jest.fn();
document.body.scrollTo = mockScrollTo;

describe('PageToTopFloatingButton', () => {
  test('<PageToTopFloatingButton> test', async () => {
    render(<PageToTopFloatingButton />);
    const user = userEvent.setup();
    const button = screen.getByRole('button', { name: 'page to top' });
    await user.click(button);
    expect(mockScrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' });
  });
});
