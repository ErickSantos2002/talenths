import ReactMarkdown, { type Components } from "react-markdown";
import { Link } from "react-router-dom";

const INTERNAL = /^\/(?!\/)\S*$/;
const EXTERNAL = /^https:\/\/\S+$/;
const CAPTURA = /^\/capturas\/[a-z0-9]+(?:-[a-z0-9]+)*\.webp$/;

const components: Components = {
  a({ href, children }) {
    if (href && INTERNAL.test(href)) return <Link to={href}>{children}</Link>;
    if (href && EXTERNAL.test(href)) {
      return (
        <a href={href} target="_blank" rel="noreferrer">
          {children}
        </a>
      );
    }
    return <>{children}</>;
  },
  img({ src, alt }) {
    if (typeof src === "string" && CAPTURA.test(src) && alt?.trim()) {
      return <img src={src} alt={alt} loading="lazy" />;
    }
    return <>{alt ?? null}</>;
  },
};

// urlTransform identidade: a validação é feita em `components`, para que
// URLs inválidas virem texto (o padrão do react-markdown geraria <a href="">).
export function GuideContent({ body }: { body: string }) {
  return (
    <div className="prose prose-sm max-w-none dark:prose-invert">
      <ReactMarkdown components={components} urlTransform={(url) => url}>
        {body}
      </ReactMarkdown>
    </div>
  );
}
