import { MemoryRouter, Route, Routes } from 'react-router';
import { renderHook } from '@testing-library/react';
import { usePage } from '../../src/hooks/usePage';

describe('usePage', () => {
  it('returns page as number', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter initialEntries={['/page/10']}>
        <Routes>
          <Route path="/page/:page" element={children} />
        </Routes>
      </MemoryRouter>
    );
    const { result } = renderHook(() => usePage(), { wrapper });
    expect(result.current).toBe(10);
  });

  it('returns 1 without page', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter initialEntries={['/']}>
        <Routes>
          <Route path="/*" element={children} />
        </Routes>
      </MemoryRouter>
    );
    const { result } = renderHook(() => usePage(), { wrapper });
    expect(result.current).toBe(1);
  });
});
