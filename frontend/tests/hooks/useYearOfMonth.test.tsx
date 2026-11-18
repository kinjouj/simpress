import { MemoryRouter, Route, Routes } from 'react-router';
import { renderHook } from '@testing-library/react';
import { useYearOfMonth } from '../../src/hooks/useYearOfMonth';

/*
import { renderHook } from '@testing-library/react';

const createWrapper = (path: string, initialEntry: string): React.FC<{ children: React.ReactNode }> => {
  const Wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
    <MemoryRouter initialEntries={[initialEntry]}>
      <Routes>
        <Route path={path} element={children} />
      </Routes>
    </MemoryRouter>
  );
  return Wrapper;
};

const requestTest = <T,>(path: string, initialEntry: string, callback: (initialProps: unknown) => unknown): T => {
  const wrapper = createWrapper(path, initialEntry);
  const { result } = renderHook(callback, { wrapper });
  return result.current as T;
};

const page = requestTest<number>('/page/:page', '/page/10', usePage);
*/

describe('hooks', () => {
  describe('useYearOfMonth', () => {
    it('returns year and month', () => {
      const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
        <MemoryRouter initialEntries={['/archives/2000/1']}>
          <Routes>
            <Route path="/archives/:year/:month" element={children} />
          </Routes>
        </MemoryRouter>
      );
      const { result } = renderHook(() => useYearOfMonth(), { wrapper });
      expect(result.current).toEqual({ year: 2000, month: 1 });
    });

    it('returns null for missing year', () => {
      const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
        <MemoryRouter initialEntries={['/archives/1']}>
          <Routes>
            <Route path="/archives/:month" element={children} />
          </Routes>
        </MemoryRouter>
      );
      const { result } = renderHook(() => useYearOfMonth(), { wrapper });
      expect(result.current).toEqual({ year: null, month: null });
    });

    it('returns null for invalid year', () => {
      const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
        <MemoryRouter initialEntries={['/archives/a/1']}>
          <Routes>
            <Route path="/archives/:year/:month" element={children} />
          </Routes>
        </MemoryRouter>
      );
      const { result } = renderHook(() => useYearOfMonth(), { wrapper });
      expect(result.current).toEqual({ year: null, month: null });
    });

    it('returns null for missing month', () => {
      const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
        <MemoryRouter initialEntries={['/archives/2000']}>
          <Routes>
            <Route path="/archives/:year" element={children} />
          </Routes>
        </MemoryRouter>
      );
      const { result } = renderHook(() => useYearOfMonth(), { wrapper });
      expect(result.current).toEqual({ year: null, month: null });
    });

    it('returns null for invalid month', () => {
      const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
        <MemoryRouter initialEntries={['/archives/2000/a']}>
          <Routes>
            <Route path="/archives/:year/:month" element={children} />
          </Routes>
        </MemoryRouter>
      );
      const { result } = renderHook(() => useYearOfMonth(), { wrapper });
      expect(result.current).toEqual({ year: null, month: null });
    });
  });
});
