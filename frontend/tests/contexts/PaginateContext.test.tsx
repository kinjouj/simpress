import { renderHook } from '@testing-library/react';
import { PaginateProvider, usePaginateContext } from '../../src/contexts/PaginateContext';

describe('PaginateContext', () => {
  test('returns the value passed to the nearest PaginateProvider', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <PaginateProvider value={{ page: 2, totalPages: 5 }}>
        {children}
      </PaginateProvider>
    );

    const { result } = renderHook(() => usePaginateContext(), { wrapper });
    expect(result.current).toEqual({ page: 2, totalPages: 5 });
  });

  test('throws when used outside of a PaginateProvider', () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => {});

    expect(() => renderHook(() => usePaginateContext())).toThrow(
      'usePaginateContext must be used within a PaginateProvider'
    );

    spy.mockRestore();
  });
});
