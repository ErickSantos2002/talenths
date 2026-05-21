---
name: fixing-accessibility
description: Audit and fix accessibility issues in TalentHS React components. Use when adding or reviewing interactive controls, forms, dialogs, or any UI that needs keyboard navigation, ARIA labels, focus management, or WCAG compliance. Prefer minimal, targeted fixes over large rewrites.
---

# fixing-accessibility

Audit the specified component or file for accessibility issues and apply targeted fixes. The stack is React 18 + TypeScript + Tailwind CSS + shadcn/ui (Radix UI primitives).

## How to Invoke

- `/fixing-accessibility` — apply rules to all UI work in this conversation
- `/fixing-accessibility <file or component>` — review that file and report violations with fixes

Do not rewrite large parts of the UI. Prefer minimal, targeted fixes. Shadcn/ui components already handle many accessibility concerns via Radix UI — don't add redundant ARIA when the primitive already provides it.

## Priority Rules

### 1. Accessible Names (critical)
- Every interactive control must have an accessible name
- Icon-only buttons must have `aria-label` or `aria-labelledby`
- Every `<input>`, `<select>`, and `<textarea>` must have a `<Label>` (shadcn Label component) or `aria-label`
- Links must have meaningful text — no "clique aqui"
- Decorative icons must have `aria-hidden="true"`

```tsx
// icon-only button
<Button size="sm" aria-label="Fechar">
  <X className="h-4 w-4" aria-hidden="true" />
</Button>
```

### 2. Keyboard Access (critical)
- Never use `<div>` or `<span>` as buttons without full keyboard support — use `<Button>` from shadcn
- All interactive elements must be reachable by Tab
- Focus must be visible for keyboard users (Tailwind `focus-visible:ring` — do not remove)
- Escape must close dialogs (Radix Dialog handles this automatically)

### 3. Focus and Dialogs (critical)
- Radix `<Dialog>` already traps focus and restores on close — don't duplicate this
- `<Sheet>`, `<Popover>`, `<DropdownMenu>` from shadcn also handle focus correctly
- Custom modals not using Radix must trap focus manually with a focus trap hook

### 4. Semantics (high)
- Use native elements (`<button>`, `<a>`, `<input>`) before adding role attributes
- Lists must use `<ul>`/`<ol>` + `<li>`
- Heading hierarchy must not skip levels (`h1` → `h2` → `h3`)
- Tables must use `<th>` for headers with `scope`

### 5. Forms and Errors (high)
- Error messages must be linked to fields via `aria-describedby`
- Invalid fields must set `aria-invalid="true"`
- Required fields must be announced (`aria-required` or native `required`)

```tsx
<Input
  id="email"
  aria-describedby={error ? "email-error" : undefined}
  aria-invalid={!!error}
/>
{error && <p id="email-error" className="text-sm text-destructive">{error}</p>}
```

### 6. Live Announcements (medium-high)
- Critical form errors should use `aria-live="polite"`
- Loading states should communicate status (`aria-busy` or visible text)
- Toasts must not be the only way to convey critical information

### 7. Contrast and States (medium)
- Text must have sufficient contrast against its background
- Disabled states must not rely on color alone — include visual texture or label
- Do not remove focus outlines without a visible replacement

### 8. Motion (low-medium)
- Respect `prefers-reduced-motion` for non-essential animations
- Use Tailwind's `motion-safe:` / `motion-reduce:` variants

```css
/* Tailwind example */
<div className="transition-all motion-reduce:transition-none">
```

## Review Output Format

When reviewing a file, report:
1. **Violation** — quote the exact line or snippet
2. **Why it matters** — one short sentence
3. **Fix** — concrete code-level suggestion

Apply fixes directly when instructed. When reporting only, keep it concise.
