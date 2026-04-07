import { act, render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import AppRoutes from '../../src/routes/AppRoutes';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';

let dataSpy: jest.SpyInstance<Promise<unknown>, [ string ]>;

describe('AppRoutes', () => {
  beforeEach(() => {
    jest.useFakeTimers();

    /* eslint-disable */
    dataSpy = jest.spyOn(Simpress as any, 'getData').mockImplementation(
      (path): Promise<any> => {
        if (path?.toString().endsWith('meta.json')) {
          return Promise.resolve(1);
        }

        switch (path) {
          case '/recent_posts.json':
            return Promise.resolve([testPostData]);
          case '/archives/page/1.json':
            return Promise.resolve([testPostData]);
          case '/archives/1234/01/1.json':
            return Promise.resolve([testPostData]);
          case '/archives/categories/test/1.json':
            return Promise.resolve([testPostData]);
          case '/test.json':
            return Promise.resolve(testPostData);
          default:
            return Promise.reject(new Error('ERROR'));
        }
      }
    ) as jest.MockInstance<Promise<any>, [ string ]>;
    /* eslint-enable */
  });

  afterEach(() => {
    jest.clearAllTimers();
    jest.useRealTimers();
    dataSpy.mockRestore();
  });

  test('<AppRoutes> initialEntries=/page/1 test', async () => {
    render(
      <MemoryRouter initialEntries={['/page/1']}>
        <AppRoutes />
      </MemoryRouter>
    );
    await act(async () => {
      void jest.runAllTimersAsync();
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/categories/test', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/categories/test/1']}>
        <AppRoutes />
      </MemoryRouter>
    );
    await act(async () => {
      void jest.runAllTimersAsync();
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/1234/01', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/1234/01/1']}>
        <AppRoutes />
      </MemoryRouter>
    );
    await act(async () => {
      void jest.runAllTimersAsync();
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/test.html', async () => {
    render(
      <MemoryRouter initialEntries={['/test.html']}>
        <AppRoutes />
      </MemoryRouter>
    );
    await act(async () => {
      void jest.runAllTimers();
      await Promise.resolve();
    });

    const post = await screen.findByRole('main');
    expect(post).toBeInTheDocument();
  });
});
