import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { renderHook } from '@testing-library/react';
import { usePermalink } from '../../src/hooks/usePermalink';

describe('usePermalink', () => {
  test('usePermalink', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter initialEntries={[`/test.html`]}>
        <Routes>
          <Route path="/*" element={children} />
        </Routes>
      </MemoryRouter>
    );

    const { result } = renderHook(() => usePermalink(), { wrapper });
    expect(result.current).toBe('/test.json');
  });

  test('permalinkパラメーターが不正な場合', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter>
        {children}
      </MemoryRouter>
    );

    const { result } = renderHook(() => usePermalink(), { wrapper });
    expect(result.current).toBeNull();
  });
});
