import { createContext, useContext } from 'react';

type PaginateContextType = {
  page: number
  totalPages: number
};

const PaginateContext = createContext<PaginateContextType | null>(null);

export const PaginateProvider = PaginateContext.Provider;

export const usePaginateContext = (): PaginateContextType => {
  const context = useContext(PaginateContext);

  if (!context) {
    throw new Error('usePaginateContext must be used within a PaginateProvider');
  }

  return context;
};
