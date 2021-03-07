// TODO Math.random() fails at runtime with missing assembly
abstract Random(UInt) {
	public static inline function fromRandomSeed():Random {
		return new Random(Std.int(Date.now().getTime()));
	}

	public inline function new(seed:UInt) {
		this = seed;
		getInt();
	}

	public inline function getInt():Int {
		return this = ((this * 48271) % 2147483647);
	}

	public inline function getFloat():Float {
		return getInt() / 2147483647;
	}
}
