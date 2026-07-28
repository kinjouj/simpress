import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import AppRoutes from '../../src/routes/AppRoutes';
import { testPostData } from '../fixtures/testPostData';

describe('AppRoutes', () => {
  beforeEach(() => {
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
    vi.spyOn(global, 'fetch').mockImplementation(async (input: RequestInfo | URL) => {
      const path = input instanceof Request ? input.url : input.toString();
      let res: Response;

      switch (true) {
        case path.endsWith('meta.json'):
          res = new Response(JSON.stringify({ total_pages: 1 }), { status: 200 });
          break;

        case path.endsWith('/recent_posts.json'):
        case path.endsWith('/archives/page/1.json'):
        case path.endsWith('/archives/1234/01/1.json'):
        case path.endsWith('/archives/categories/test/1.json'):
          res = new Response(JSON.stringify([testPostData]), { status: 200 });
          break;

        case path.endsWith('/test.json'):
          res = new Response(JSON.stringify(testPostData), { status: 200 });
          break;

        default:
          res = new Response(null, { status: 404, statusText: 'Not Found' });
      }

      return Promise.resolve(res);
    });
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  test('<AppRoutes> initialEntries=/page/1 test', async () => {
    render(
      <MemoryRouter initialEntries={['/page/1']}>
        <AppRoutes />
      </MemoryRouter>
    );

    const posts = await screen.findAllByRole('listitem', { name: 'post' }, { timeout: 10000 });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/categories/test', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/categories/test/1']}>
        <AppRoutes />
      </MemoryRouter>
    );

    const posts = await screen.findAllByRole('listitem', { name: 'post' }, { timeout: 10000 });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/1234/01', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/1234/01/1']}>
        <AppRoutes />
      </MemoryRouter>
    );

    const posts = await screen.findAllByRole('listitem', { name: 'post' }, { timeout: 10000 });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/test.html', async () => {
    render(
      <MemoryRouter initialEntries={['/test.html']}>
        <AppRoutes />
      </MemoryRouter>
    );

    const post = await screen.findByRole('main', {}, { timeout: 10000 });
    expect(post).toBeInTheDocument();
  });
});
