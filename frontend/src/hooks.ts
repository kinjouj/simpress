import { useParams } from 'react-router-dom';

export const usePage = (): number => {
  const { page = '1' } = useParams();
  return parseInt(page, 10);
};

export const useYearOfMonth = (): { year: number | null, month: number | null } => {
  const { year, month } = useParams();
  let parsedYear: number | null = null;
  let parsedMonth: number | null = null;

  if (typeof year === 'string') {
    const y = parseInt(year, 10);
    parsedYear = isNaN(y) ? null : y;
  }

  if (typeof month === 'string') {
    const m = parseInt(month, 10);

    if (!isNaN(m) && m >= 1 && m <= 12) {
      parsedMonth = m;
    }
  }

  if (parsedYear === null || parsedMonth === null) {
    return { year: null, month: null };
  }

  return { year: parsedYear, month: parsedMonth };
};

export const useCategory = (): string | null => {
  const { category } = useParams<{ category: string | undefined }>();

  return category ?? null;
};

export const usePermalink = (): string | null => {
  const { '*': permalink } = useParams<{ '*': string | undefined }>();

  return permalink ?? null;
};
