import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { WELCOME_TOURS } from "./welcome";

const SOURCE = readFileSync(resolve(__dirname, "../../../../backend/app/routers/tour.py"), "utf8");

describe("backend tour ids", () => {
  it("WELCOME_TOUR_IDS matches the welcome tours", () => {
    const block = SOURCE.match(/WELCOME_TOUR_IDS\s*=\s*\{([^}]*)\}/)?.[1] ?? "";
    expect(block).toContain(`"collaborator": "${WELCOME_TOURS.collaborator.id}"`);
    expect(block).toContain(`"manager": "${WELCOME_TOURS.manager.id}"`);
  });
});
