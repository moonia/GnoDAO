package utils

import (
	"std"
)

func GetCaller() std.Address {
	return std.PreviousRealm().Address()
}