package home

import (
	"std"
	"strconv"
	"gno.land/p/moul/txlink"
	"gno.land/p/moul/md"
	"gno.land/p/moonia/utils"
)
type DAO struct {
	Whitelist map[std.Address]bool
	Proposals []Proposal
}
// TODO: move out to p/dao
type Proposal struct {
	Title       string
	Description string
	Creator     std.Address
	YesVotes    int
	NoVotes     int
	Voters      map[std.Address]bool
	Active      bool
}

var myDAO DAO

func init() {
	myDAO = DAO{
		Whitelist: make(map[std.Address]bool),
		Proposals: []Proposal{},
	}
}

// TODO: move method to r/dao
func JoinWhitelist() {
	caller := utils.GetCaller()
	if myDAO.Whitelist[caller] {
		panic("You're already in the whitelist.")
	}
	myDAO.Whitelist[caller] = true
}

// TODO: move method to r/dao
func ShowWhitelist() string {
	out := "## Whitelist Members ✅\n\n"
	if len(myDAO.Whitelist) == 0 {
		return out + "_Whitelist is empty._\n"
	}
	for addr := range myDAO.Whitelist {
		out += "- " + addr.String() + "\n"
	}
	return out
}

// TODO: move method to r/dao
func CreateProposal(title string, description string) string {
	caller := utils.GetCaller()
	if !myDAO.Whitelist[caller] {
		panic("Only whitelisted members can create proposals.")
	}
	p := Proposal{
		Title:       title,
		Description: description,
		Creator:     caller,
		YesVotes:    0,
		NoVotes:     0,
		Voters:      make(map[std.Address]bool),
		Active:      true,
	}
	myDAO.Proposals = append(myDAO.Proposals, p)
	return "📢 Proposal created: " + title
}

// TODO: move method to r/dao
func Vote(indexStr string, voteYesStr string) {
	index, err := strconv.Atoi(indexStr)
	if err != nil {
		panic("Invalid proposal index format.")
	}

	voteYes := voteYesStr == "true"
	caller := utils.GetCaller()

	if !myDAO.Whitelist[caller] {
		panic("Only whitelisted members can vote.")
	}
	// for cli
	if index < 0 || index >= len(myDAO.Proposals) {
		panic("Invalid proposal index.")
	}
	p := &myDAO.Proposals[index]
	if !p.Active {
		panic("Voting is closed for this proposal.")
	}
	if p.Voters[caller] {
		panic("You have already voted.")
	}

	p.Voters[caller] = true
	if voteYes {
		p.YesVotes++
	} else {
		p.NoVotes++
	}
}

// default test
// or
// gnokey maketx call -pkgpath "gno.land/r/moonia/home" -func "CreateProposal" -args "TITLE" -args "DESCRIPTION" -gas-fee 1000000ugnot -gas-wanted 5000000 -broadcast -chainid "dev" -remote "tcp://127.0.0.1:26657" ADDRESSHERE
func CreateProposalTest() string {
	return CreateProposal("Survey", "Would you like to visit guatemala?")
}

func CloseProposal(indexStr string) string {
	index, err := strconv.Atoi(indexStr)
	if err != nil {
		panic("Invalid index.")
	}
	if index < 0 || index >= len(myDAO.Proposals) {
		panic("Proposal does not exist.")
	}
	caller := utils.GetCaller()
	p := &myDAO.Proposals[index]
	if p.Creator != caller {
		panic("Only the proposal creator can close it.")
	}
	if !p.Active {
		panic("Proposal is already closed.")
	}
	p.Active = false
	return "✅ Proposal '" + p.Title + "' has been closed."
}

func ShowProposals() string {
	activeOut := "## Active Proposals\n\n"
	closedOut := "## Closed Proposals\n\n"
	hasActive := false
	hasClosed := false

	for i, p := range myDAO.Proposals {
		proposalStr := "**[" + strconv.Itoa(i) + "]** " + p.Title + "\n"
		proposalStr += p.Description + "\n\n"
		proposalStr += "by _" + p.Creator.String() + "_\n\n"
		proposalStr += "✅ " + strconv.Itoa(p.YesVotes) + " | ❌ " + strconv.Itoa(p.NoVotes) + "\n"

		if p.Active {
			hasActive = true
			proposalStr += "(Active) — " +
				md.Link("Vote Yes", txlink.Call("Vote", "args", strconv.Itoa(i), "args", "true")) + " | " +
				md.Link("Vote No", txlink.Call("Vote", "args", strconv.Itoa(i), "args", "false")) + "\n\n" +
				md.Link("❌ Close proposal", txlink.Call("CloseProposal", "args", strconv.Itoa(i))) + "\n\n ---"
			activeOut += proposalStr + "\n\n"
		} else {
			hasClosed = true
			proposalStr += "(Closed)\n"
			closedOut += proposalStr + "\n\n ---- \n\n"
		}
	}

	if !hasActive {
		activeOut += "_No active proposals._\n\n"
	}
	if !hasClosed {
		closedOut += "_No closed proposals._\n\n"
	}
	return activeOut + "\n" + closedOut
}

func Stats() string {
	total := len(myDAO.Proposals)
	active := 0
	for _, p := range myDAO.Proposals {
		if p.Active {
			active++
		}
	}
	return "### Stats\n\n" +
		"- Total Proposals: " + strconv.Itoa(total) + "\n" +
		"- Active Proposals: " + strconv.Itoa(active) + "\n" +
		"- Whitelist Members: " + strconv.Itoa(len(myDAO.Whitelist)) + "\n"
}

func renderDAO() string {
	out := "# Moonia's DAO\n\n"
	out += Stats() + "\n"
	out += "## Actions:\n\n"
	out += "- " + md.Link("Join Whitelist", txlink.Call("JoinWhitelist")) + "\n"
	out += "- " + md.Link("Create Sample Proposal", txlink.Call("CreateProposalTest")) + "\n"
	out += ShowWhitelist() + "\n"
	out += ShowProposals()
	return out
}

func Render(path string) string {
	return renderDAO()
}

