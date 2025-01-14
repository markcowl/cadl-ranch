import { mkdir } from "fs/promises";
import { glob } from "glob";

export async function findFilesFromPattern(pattern: string): Promise<string[]> {
  return glob(pattern);
}

/**
 * Ensure the given dir exists.
 * @param path Path to the dir.
 */
export async function ensureDir(path: string): Promise<void> {
  await mkdir(path, { recursive: true });
}
