import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import CreatedAt from '../../../src/components/ui/CreatedAt';

describe('CreatedAt Component', () => {
  it('shows linked YYYY-MM-DD date', () => {
    const date = { year: 2000, month: 1, day: 1, hour: 0, minute: 0, second: 0, utc_offset: 32400 };
    render(
      <MemoryRouter>
        <CreatedAt date={date} />
      </MemoryRouter>
    );

    const elm = screen.queryByRole('time');
    expect(elm).toHaveTextContent('2000-01-01');
    expect(elm).toHaveAttribute('datetime', '2000-01-01');
    expect(screen.getByRole('link')).toHaveAttribute('href', '/archives/2000/01');
  });

  it('shows nothing when null', () => {
    render(
      <MemoryRouter>
        <CreatedAt date={null} />
      </MemoryRouter>
    );

    expect(screen.queryByRole('time')).toBeNull();
  });
});
