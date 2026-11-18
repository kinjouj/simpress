import { MemoryRouter, Route, Routes } from 'react-router';
import { renderHook } from '@testing-library/react';
import { useCategory } from '../../src/hooks/useCategory';

describe('useCategor', () => {
  it('returns the category', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter initialEntries={['/archives/categories/test']}>
        <Routes>
          <Route path="/archives/categories/:category" element={children} />
        </Routes>
      </MemoryRouter>
    );
    const { result } = renderHook(() => useCategory(), { wrapper });
    expect(result.current).toBe('test');
  });

  it('returns null if invalid', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <MemoryRouter initialEntries={['/']}>
        <Routes>
          <Route path="/*" element={children} />
        </Routes>
      </MemoryRouter>
    );
    const { result } = renderHook(() => useCategory(), { wrapper });
    expect(result.current).toBeNull();
  });
});
