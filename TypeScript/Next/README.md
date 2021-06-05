# Next.js（TypeScript）
※create-next-app：10.2.4 における手順

## 環境構築
create-next-app で雛形作成
```bash
$ yarn create next-app [pj-name]
```
※テンプレートを使用したい場合は、`--example`で指定する

サーバ立ち上げ
```
$ yarn dev
```

ブラウザからアクセス
```
localhost:3000
```
Next.js の開発サーバでは高速更新が有効になっている。 そのため、ファイルを変更すると即時にブラウザに自動反映する。

## TypeScript 対応
空の tsconfig.json 作成
```
$ touch tsconfig.json
```

この後にサーバを立ち上げなおすと、サーバが起動せず TypeScript のライブラリをインストールするように案内が表示されるようになっている。  
```
It looks like you're trying to use TypeScript but do not have the required package(s) installed.

Please install typescript and @types/react by running:

        yarn add --dev typescript @types/react

If you are not trying to use TypeScript, please remove the tsconfig.json file from your package root (and any TypeScript files in your pages directory).
```

その案内されたライブラリをインストールする。
```
$ yarn add -D typescript @types/react
```

再度サーバ再起動で Next.js は以下のことを行う。
- tsconfig.json：ファイルにデータを入力
- next-env.d.ts：ファイルを作成

next-env.d.ts によって、Next.js の型が TypeScript コンパイラによって確実に取得されるようになる。このファイルには触れないこと。

### 既存ファイルの TypeScript 化
・pages/index.js → pages/index.tsx へ

・pages/_app.js → pages/_app.tsx にして、型追加
```tsx
import { AppProps } from 'next/app'

function MyApp({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}

export default MyApp
```

・pages/api/hello.js → pages/api/hello.ts へ
```tsx
// Next.js API route support: https://nextjs.org/docs/api-routes/introduction

import { NextApiRequest, NextApiResponse } from 'next';

export default (_: NextApiRequest, res: NextApiResponse) => {
  res.status(200).json({ text: 'Hello' });
};

```

## その他調整
`src`ディレクトリを作り、その中に pages や styles ディレクトリを入れる。
こうすると、ESLint 設定のパス指定などやりやすくなる。

ESLint 等の設定は、[上階層の README](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/React/README.md) を参照。
