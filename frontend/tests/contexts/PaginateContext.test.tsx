import { renderHook } from '@testing-library/react';
import { PaginateProvider, usePaginateContext } from '../../src/contexts/PaginateContext';

describe('PaginateContext', () => {
  it('returns nearest provider value', () => {
    const wrapper = ({ children }: { children: React.ReactNode }): React.JSX.Element => (
      <PaginateProvider value={{ page: 2, totalPages: 5 }}>
        {children}
      </PaginateProvider>
    );
    const { result } = renderHook(() => usePaginateContext(), { wrapper });
    expect(result.current).toEqual({ page: 2, totalPages: 5 });
  });

  it('throws outside the provider', () => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
    expect(() => renderHook(() => usePaginateContext())).toThrow('usePaginateContext must be used within a PaginateProvider');
  });
});
