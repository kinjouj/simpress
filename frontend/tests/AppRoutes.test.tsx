import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import AppRoutes from '../src/AppRoutes';
import type { PostType } from '../src/types';
import Simpress from '../src/simpress';
import '@testing-library/jest-dom';

/*
const mockGetPostsByPage = jest.fn<Promise<PostType[]>, [ number ]>();
const mockGetPostsByCategory = jest.fn<Promise<PostType[]>, [ string ]>();
const mockGetPostsByArchive = jest.fn<Promise<PostType[]>, [ number, number]>();
const mockGetPost = jest.fn<Promise<PostType>, [ string ]>();
jest.mock('../src/simpress', (): Simpress => ({
  getPostsByPage: (page: number) => mockGetPostsByPage(page),
  getPostsByCategory: (category: string) => mockGetPostsByCategory(category),
  getPostsByArchive: (year: number, month: number) => mockGetPostsByArchive(year, month),
  getPost: (path: string) => mockGetPost(path),
}));
*/

const testData: PostType = {
  id: '1',
  title: 'test1',
  date: Date.now().toString(),
  permalink: '/test.html',
  cover: '/images/no_image.png',
  categories: [{ key: 'test', count: 1, name: 'Test' }],
  content: 'test1',
};

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
            return Promise.resolve([testData]);
          case '/archives/1234/01.json':
            return Promise.resolve([testData]);
          case '/archives/category/test.json':
            return Promise.resolve([testData]);
          case '/test.json':
            return Promise.resolve(testData);
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

    const posts = await screen.findAllByRole('list', { name: 'post' });
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

    const posts = await screen.findAllByRole('list');
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

    const posts = await screen.findAllByRole('list');
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
