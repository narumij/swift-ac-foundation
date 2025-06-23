/// 真ならYesを返す、偽ならNoを返す
@usableFromInline
func Yes(_ b: Bool = true) -> String { b ? .Yes : .No }

/// 真ならNoを返す、偽ならYesを返す
@usableFromInline
func No(_ b: Bool = true) -> String { Yes(!b) }

/// 真ならYESを返す、偽ならNOを返す
@usableFromInline
func YES(_ b: Bool = true) -> String { b ? .YES : .NO }

/// 真ならNOを返す、偽ならYESを返す
@usableFromInline
func NO(_ b: Bool = true) -> String { YES(!b) }

/// 真ならTakahashiを返す、偽ならAokiを返す
@usableFromInline
func Takahashi(_ b: Bool = true) -> String { b ? .Takahashi : .Aoki }

/// 真ならAokiを返す、偽ならTakahashiを返す
@usableFromInline
func Aoki(_ b: Bool = true) -> String { Takahashi(!b) }
