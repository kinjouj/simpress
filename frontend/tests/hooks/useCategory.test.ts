import * as Router from 'react-router';
import { useCategory } from '../../src/hooks/useCategory';

vi.mock('react-router', async () => {
  const actual = await vi.importActual<typeof Router>('react-router');
  return {
    ...actual,
    useParams: vi.fn(),
  };
});

const mockedUseParams = vi.mocked(Router.useParams);

describe('useCategor', () => {
  afterEach(() => {
    mockedUseParams.mockReset();
  });

  test('useCategory test', () => {
    mockedUseParams.mockReturnValue({ category: 'test' });
    expect(useCategory()).toBe('test');
  });

  test('categoryパラメーターが不正な場合', () => {
    mockedUseParams.mockReturnValue({});
    expect(useCategory()).toBeNull();
  });
});
