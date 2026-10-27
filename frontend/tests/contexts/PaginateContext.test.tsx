import { renderHook } from '@testing-library/react';
import { PaginateProvider, usePaginateContext } from '../../src/contexts/PaginateContext';

describe('PaginateContext', () => {
  it('最も近いPaginateProviderの値を返す', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <PaginateProvider value={{ page: 2, totalPages: 5 }}>
        {children}
      </PaginateProvider>
    );

    const { result } = renderHook(() => usePaginateContext(), { wrapper });
    expect(result.current).toEqual({ page: 2, totalPages: 5 });
  });

  it('PaginateProvider外で使うと例外を投げる', () => {
    vi.spyOn(console, 'error').mockImplementation(() => {});

    expect(() => renderHook(() => usePaginateContext())).toThrow(
      'usePaginateContext must be used within a PaginateProvider'
    );
  });
});
