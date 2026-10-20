// Only loaded through `import()` in guides.ts, so the guide text stays out of the main bundle.
export const RAW_GUIDES: Record<string, string> = import.meta.glob("./guides/**/*.md", {
  query: "?raw",
  import: "default",
  eager: true,
});
