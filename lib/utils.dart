class Utils
{
  static matchValue(RegExpMatch match) => match.input.substring(match.start + 1, match.end - 1);
}