import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import AppRoutes from '../../src/routes/AppRoutes';
import Simpress from '../../src/api/simpress';
import { testPostData } from '../fixtures/testPostData';

let dataSpy: jest.SpyInstance<Promise<unknown>, [ string ]>;

describe('AppRoutes', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    /* eslint-disable */
    dataSpy = jest.spyOn(Simpress as any, 'getData').mockImplementation(
      (path): Promise<any> => {
        switch (path) {
          case '/pageinfo.json':
            return Promise.resolve({ page: 10 });
          case '/archives/page/1.json':
            return Promise.resolve([testPostData]);
          case '/archives/1234/01.json':
            return Promise.resolve([testPostData]);
          case '/archives/category/test.json':
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
    jest.useRealTimers();
    dataSpy.mockRestore();
  });

  test('<AppRoutes> initialEntries=/page/1 test', async () => {
    render(
      <MemoryRouter initialEntries={['/page/1']}>
        <AppRoutes />
      </MemoryRouter>
    );

    await waitFor(() => expect(dataSpy).toHaveBeenCalledTimes(1));
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });
    await waitFor(() => expect(dataSpy).toHaveBeenCalledTimes(2));

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/category/test', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/category/test']}>
        <AppRoutes />
      </MemoryRouter>
    );

    await waitFor(() => expect(dataSpy).toHaveBeenCalledTimes(1));
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/archives/1234/01', async () => {
    render(
      <MemoryRouter initialEntries={['/archives/1234/01']}>
        <AppRoutes />
      </MemoryRouter>
    );

    await waitFor(() => expect(dataSpy).toHaveBeenCalledTimes(1));
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('<AppRoutes> initialEntries=/test.json', async () => {
    render(
      <MemoryRouter initialEntries={['/test.json']}>
        <AppRoutes />
      </MemoryRouter>
    );

    await waitFor(() => expect(dataSpy).toHaveBeenCalledTimes(1));
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const post = await screen.findByRole('main');
    expect(post).toBeInTheDocument();
  });
});
