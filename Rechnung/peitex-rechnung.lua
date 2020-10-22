invoice={
	items={},
	vat={},
}

function invoice.additem( VAT, Amount, Desc, Price)
   table.insert( invoice.items[VAT],
		 {
		    Amount=Amount,
		    Desc=Desc,
		    Price=Price,
		    Pricetotal=(math.floor(100*Amount*Price+0.5)/100),
		 }
   )
end

function invoice.printitems()
	for vat,child in pairs(invoice.items) do 
		local Vat  = invoice.vat[vat]*100
		for _, item in pairs (child) do
			tex.print( "\\PrintInvoiceItem["..Vat.."]{"..item.Amount.."}{"..item.Desc.."}{"..item.Price.."}{"..item.Pricetotal.."}")
		end
	end
end

function invoice.sumupvat(group)
	local Vat=invoice.vat[group]
	print(group)
	local items = invoice.items[group]
	if next(items) == nil then
		return 0,0,0
	else
		local netto,vat,brutto
		netto = invoice.netto(items)
		vat=Vat*netto
		brutto=netto+vat
		return netto, vat, brutto
	end
end

function invoice.printsumvat()
	local Netto, Brutto
	Netto=0
	Brutto=0
	local Vat={}
	for _,group in pairs(invoice.items) do 
		local netto, vat, bruttoa
  		netto, vat, brutto = invoice.sumupvat(_)
  		Netto=Netto+netto
  		Brutto=Brutto+brutto
  		Vat[_]={vat=vat,netto=netto}
  	end
	tex.print("\\PrintInvoiceSum{netto}{"..Netto.."}")
	local vatsum 
	for i,v in pairs(Vat) do
		print(i.."-"..tostring(v["netto"]).."-"..tostring(invoice.vat[i]))
		vatsum = v["vat"]
		if vatsum == 0 then
		else
		tex.print("\\PrintVatSum["..v["netto"].."]{"..tostring(invoice.vat[i]*100).."}{"..tostring(v["vat"]).."}")
		end
	end
	tex.print("\\PrintInvoiceSum{brutto}{"..Brutto.."}")
end

function invoice.netto(items)
	local i, p
	local sum = 0
	for i,p in pairs( items ) do
		sum = sum + p.Pricetotal
	end
	return sum
end

