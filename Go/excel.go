package main

import (
	"fmt"
	"strconv"

	"github.com/360EntSecGroup-Skylar/excelize"
)

func excel(KK Kit, PP []Login, IndexKit int) {
	f := excelize.NewFile()

	f.SetCellValue("Sheet1", "A2", KK.title)
	fmt.Println(KK.items)
	for i := 0; i < len(KK.items); i++ {
		a := string(rune('F'-1+i)) + "4"
		f.SetCellValue("Sheet1", a, KK.items[i].name)
		a = string(rune('F'-1+i)) + "3"
		f.SetCellValue("Sheet1", a, KK.items[i].Psocio+"/"+KK.items[i].PNsocio)
	}
	a := string(rune('B')) + "4"
	f.SetCellValue("Sheet1", a, "Nomes")
	a = string(rune('C')) + "4"
	f.SetCellValue("Sheet1", a, "Número")
	a = string(rune('K')) + "4"
	f.SetCellValue("Sheet1", a, "Socio?")
	a = string(rune('L')) + "4"
	f.SetCellValue("Sheet1", a, "Preço")
	a = string(rune('M')) + "4"
	f.SetCellValue("Sheet1", a, "Pagou?")

	ll := 6

	fmt.Print(KK.quemquer)

	for i := 0; i < len(KK.quemquer); i++ {
		for p := 0; p < len(Logins); p++ {
			if Logins[p].aluno == KK.quemquer[i] /*|| Logins[p].aluno == KK.levou[i]*/ {
				a := string(rune('A')) + strconv.Itoa(ll)
				f.SetCellValue("Sheet1", a, ll-5)
				a = string(rune('B')) + strconv.Itoa(ll)
				f.SetCellValue("Sheet1", a, Logins[p].nome)
				a = string(rune('C')) + strconv.Itoa(ll)
				num, _ := strconv.Atoi(Logins[p].aluno)
				f.SetCellValue("Sheet1", a, num)
				preco := 0.0
				fmt.Print(Logins[p].aluno)
				fmt.Print("   -   ")
				for j := 0; j < len(KK.items); j++ {
					a = string(rune('F'-1+j)) + strconv.Itoa(ll)
					b := ""
					fmt.Println(Logins[p].kits[IndexKit].k[j])
					if Logins[p].kits[IndexKit].k[j] == true {
						if Logins[p].cotas == false {
							pppp, _ := strconv.ParseFloat(KK.items[j].Psocio, 64)
							preco += pppp
						} else {
							pppp, _ := strconv.ParseFloat(KK.items[j].PNsocio, 64)
							preco += pppp
						}
						b = "X"
					}
					fmt.Print(" | ")
					fmt.Print(a)
					f.SetCellValue("Sheet1", a, b)
				}
				fmt.Println()
				a = string(rune('K')) + strconv.Itoa(ll)
				if true == Logins[p].cotas {
					f.SetCellValue("Sheet1", a, "X")
				}
				a = string(rune('L')) + strconv.Itoa(ll)
				f.SetCellValue("Sheet1", a, preco)
				for j := 0; j < len(KK.pagou); j++ {
					a = string(rune('M')) + strconv.Itoa(ll)
					if KK.pagou[j] == Logins[p].aluno {
						f.SetCellValue("Sheet1", a, "X")
					}
				}
				a = string(rune('N')) + strconv.Itoa(ll)
				f.SetCellValue("Sheet1", a, Logins[p].telemovel)
				ll++

			}

		}
	}

	b := KK.title + ".xlsx"
	//f.SaveAs(b);
	if err := f.SaveAs(b); err != nil {
		println(err.Error())
	}
}

func excelPeople(PP []Login, KK []Kit) {
	counter := 1
	for i := 0; i < len(KK); i++ {
		fmt.Println(KK[i].title)
		for j := 0; j < len(KK[i].levou); j++ {
			for k := 0; k < len(PP); k++ {
				if PP[k].aluno == KK[i].levou[j] {
					fmt.Println(PP[k].aluno)
					if PP[k].cotas == true && (PP[k].socio == "" || PP[k].socio == " ") && PP[k].more == "" {
						PP[k].more = strconv.Itoa(counter)
						counter++
					}
				}
			}
		}
	}
	for i := 0; i < len(PP); i++ {
		if PP[i].cotas == true && (PP[i].socio == "" || PP[i].socio == " ") && PP[i].more == "" {
			PP[i].more = "XX" + strconv.Itoa(counter)
			counter++
		}
	}
	f := excelize.NewFile()
	f.SetCellValue("Sheet1", "B2", "Numero")
	f.SetCellValue("Sheet1", "C2", "Nome")
	f.SetCellValue("Sheet1", "D2", "Mail")
	f.SetCellValue("Sheet1", "E2", "Telemovel")
	f.SetCellValue("Sheet1", "F2", "Nº Socio")
	f.SetCellValue("Sheet1", "G2", "Cotas")
	f.SetCellValue("Sheet1", "I2", "Novo Socio")
	fmt.Println(len(PP))
	fmt.Println(counter)
	for i := 0; i < len(PP); i++ {
		a := string(rune('B')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].aluno)
		a = string(rune('C')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].nome)
		a = string(rune('D')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].mail)
		a = string(rune('E')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].telemovel)
		a = string(rune('F')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].socio)
		a = string(rune('G')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].cotas)
		a = string(rune('I')) + strconv.Itoa(i+3)
		f.SetCellValue("Sheet1", a, PP[i].more)
	}
	b := "Pessoas.xlsx"
	if err := f.SaveAs(b); err != nil {
		println(err.Error())
	}
}
