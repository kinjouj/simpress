import * as Router from 'react-router-dom';
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

jest.mock('react-router-dom', (): typeof Router => ({
  ...jest.requireActual('react-router-dom'),
  useParams: jest.fn(),
}));

const mockedUseParams = Router.useParams as jest.Mock;

describe('hooks', () => {
  describe('useYearOfMonth', () => {
    afterEach(() => {
      mockedUseParams.mockReset();
    });

    test('useYearOfMonth test', () => {
      mockedUseParams.mockReturnValue({ year: '2000', month: '1' });
      const yearOfMonth = useYearOfMonth();
      expect(yearOfMonth).toHaveProperty('year', 2000);
      expect(yearOfMonth).toHaveProperty('month', 1);
    });

    test('yearパラメーターが不正な場合', () => {
      mockedUseParams.mockReturnValue({ year: null, month: '1' });
      const yearOfMonth = useYearOfMonth();
      expect(yearOfMonth).toHaveProperty('year', null);
      expect(yearOfMonth).toHaveProperty('month', null);
    });

    test('yearパラメーターが"a"の場合', () => {
      mockedUseParams.mockReturnValue({ year: 'a', month: '1' });
      const yearOfMonth = useYearOfMonth();
      expect(yearOfMonth.year).toBeNull();
      expect(yearOfMonth.month).toBeNull();
    });

    test('monthパラメーターが不正な場合', () => {
      mockedUseParams.mockReturnValue({ year: '2000', month: null });
      const yearOfMonth = useYearOfMonth();
      expect(yearOfMonth).toHaveProperty('year', null);
      expect(yearOfMonth).toHaveProperty('month', null);
    });

    test('monthパラメーターが"a"の場合', () => {
      mockedUseParams.mockReturnValue({ year: '2000', month: 'a' });
      const yearOfMonth = useYearOfMonth();
      expect(yearOfMonth).toHaveProperty('year', null);
      expect(yearOfMonth).toHaveProperty('month', null);
    });
  });
});
