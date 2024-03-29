# スタイルに関する環境構築

## リセット CSS
ブラウザごとのデフォルト CSS による差異をなるべく減らすために、リセット CSS をグローバルで適用。  
種類は色々あるのでお好みで。

```bash
npm i modern-css-reset
```

## emotion
CSS in JS の一種。

### Next.js における導入手順
本体のインストール
```bash
npm i @emotion/react
```

next.config.js で emotion を有効化
```js
compiler: {
  emotion: true
}
```

Next.js v12.2 からは emotion が標準サポートされたため、基本的にはこれだけで使用できる。

ただ、CSS Prop の機能を使うには、使用ファイルそれぞれに`/** @jsxImportSource @emotion/react */`というプラグマを書く必要がある。

tsconfig.json に追記は必要  
（これがないと CSS Prop を書こうとしても、そんなプロパティはないとエラーになる）
```json
{
  "compilerOptions": {
    // ...
    "jsxImportSource": "@emotion/react"
  }
}
```

<details>
<summary>v12.1.0までで CSS Prop を使うために必要な Babel プラグイン設定</summary>
これを都度書かなくていいようにするには、以下の手順を行う。

Babel 用の preset をインストール（core も必要になるので入れる）
```bash
npm i -D @emotion/babel-preset-css-prop @babel/core
```

.babelrc を作成し、この preset を使うようにする
```
{
  "presets": ["next/babel", "@emotion/babel-preset-css-prop"]
}
```

</details>

### VSCode 拡張
- [vscode-styled-components](https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components)

styled-components 形式コードの、シンタックスハイライトや入力補完を追加。

入れるだけで OK。  
styled-components 用であるが、emotion でも問題なく動作する。

### Next.js(Pages Router) で PostCSS と共存させる手順
SSR 前提になってしまうことに注意。

必要なパッケージを導入
```bash
npm i @emotion/cache @emotion/server postcss postcss-preset-env
```

emotion のキャッシュ生成用、PostCSS 使用のファイル作成。  
（Next/lib 配下のファイル参照）

_app.tsx で emotion のキャッシュを使用するようにする（CacheProvider の部分）
```tsx
import { AppProps } from 'next/app';
import { Global, CacheProvider, EmotionCache } from '@emotion/react';
import { globalStyle } from '@/styles/globals';
import { createEmotionCache } from '@/lib/emotionCache';

const clientSideEmotionCache = createEmotionCache();
interface MyAppProps extends AppProps {
  emotionCache?: EmotionCache;
}

const MyApp = ({
  Component,
  pageProps,
  emotionCache = clientSideEmotionCache,
}: MyAppProps) => {
  return (
    <CacheProvider value={emotionCache}>
      <Global styles={globalStyle} />
      <Component {...pageProps} />
    </CacheProvider>
  );
};

export default MyApp;
```

_document.tsx で getInitialProps による、ページ加工処理を追加
```tsx
import { Children } from 'react';
import Document, { Html, Head, Main, NextScript } from 'next/document';
import createEmotionServer from '@emotion/server/create-instance';
import { createEmotionCache } from '@/lib/emotionCache';
import { processedCss } from '@/lib/postCss';
.
.
.
MyDocument.getInitialProps = async (ctx) => {
  const originalRenderPage = ctx.renderPage;
  const cache = createEmotionCache();
  const { extractCriticalToChunks } = createEmotionServer(cache);

  ctx.renderPage = () =>
    originalRenderPage({
      enhanceApp: (App: any) => (props) => (
        <App emotionCache={cache} {...props} />
      ),
    });

  const initialProps = await Document.getInitialProps(ctx);
  const emotionStyles = extractCriticalToChunks(initialProps.html);
  const emotionStyleTags = emotionStyles.styles.map((style) => {
    const processedStyle = processedCss(style.css);

    return (
      <style
        data-emotion={`${style.key} ${style.ids.join(' ')}`}
        key={style.key}
        dangerouslySetInnerHTML={{ __html: processedStyle }}
      />
    );
  });

  return {
    ...initialProps,
    styles: [...Children.toArray(initialProps.styles), ...emotionStyleTags],
  };
};
```
