import * as Router from 'react-router';
import { usePage } from '../../src/hooks/usePage';

vi.mock('react-router', async () => {
  const actual = await vi.importActual<typeof Router>('react-router');
  return {
    ...actual,
    useParams: vi.fn(),
  };
});

const mockedUseParams = vi.mocked(Router.useParams);

describe('usePage', () => {
  it('usePage test', () => {
    mockedUseParams.mockReturnValue({ page: '10' });
    const page = usePage();
    expect(page).toBe(10);
  });

  it('if useParams return null', () => {
    mockedUseParams.mockReturnValue({});
    expect(usePage()).toBe(1);
  });
});
