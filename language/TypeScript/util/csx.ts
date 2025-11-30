import { color } from 'csx';

/**
 * 色情報に対して、白か黒かコントラスト比が大きい方の色を返す
 * ref: https://katashin.info/2018/12/18/247
 * @param colorValue - 色情報（16進数カラーコード値 or CSS カラー関数）
 * @param whiteColor - 使用候補の白系の色情報
 * @param blackColor - 使用候補の黒系の色情報
 * @return - 白か黒かコントラスト比が大きい方の色情報
 */
export const selectContrastTextColor = (
  colorValue: string,
  {
    whiteColor = 'white',
    blackColor = 'black',
  }: Partial<{ whiteColor: string; blackColor: string }> = {},
): string => {
  // sRGB 形式の色を RGB 形式の色に変換（CSS の色の値は sRGB）
  const sRGBtoRGBItem = (color: number) => {
    const i = color / 255;
    return i <= 0.03928 ? i / 12.92 : Math.pow((i + 0.055) / 1.055, 2.4);
  };

  const R = sRGBtoRGBItem(color(colorValue).red());
  const G = sRGBtoRGBItem(color(colorValue).green());
  const B = sRGBtoRGBItem(color(colorValue).blue());
  // 背景色の相対輝度を計算
  const Lbg = 0.2126 * R + 0.7152 * G + 0.0722 * B;

  // 白と黒の相対輝度（WCAG 定義より、それぞれ1と0）
  const Lw = 1;
  const Lb = 0;

  // 白と背景色のコントラスト比、黒と背景色のコントラスト比をそれぞれ計算
  const Cw = (Lw + 0.05) / (Lbg + 0.05);
  const Cb = (Lbg + 0.05) / (Lb + 0.05);

  // コントラスト比が大きい方を文字色として返す
  return Cw < Cb ? blackColor : whiteColor;
};
