import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import '@testing-library/jest-dom';
import CreatedAt from '../../src/components/CreatedAt';

describe('CreatedAt Component', () => {
  test('CreatedAt test', () => {
    render(
      <MemoryRouter>
        <CreatedAt dateString="2000-01-01T00:00:00" />
      </MemoryRouter>
    );

    const elm = screen.queryByRole('time');
    expect(elm).toHaveTextContent('2000-01-01');
  });

  test('dateStringが不正な場合', () => {
    render(
      <MemoryRouter>
        <CreatedAt dateString="" />
      </MemoryRouter>
    );

    const elm = screen.queryByRole('time');
    expect(elm).toBeNull();
  });
});
