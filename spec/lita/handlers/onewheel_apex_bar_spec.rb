require 'spec_helper'

describe Lita::Handlers::OnewheelApexBar, lita_handler: true do
  it { is_expected.to route_command('apex') }
  it { is_expected.to route_command('apex 4') }
  # it { is_expected.to route_command('apex nitro') }
  # it { is_expected.to route_command('apex CASK') }
  it { is_expected.to route_command('apex <$4') }
  it { is_expected.to route_command('apex < $4') }
  it { is_expected.to route_command('apex <=$4') }
  it { is_expected.to route_command('apex <= $4') }
  it { is_expected.to route_command('apex >4%') }
  it { is_expected.to route_command('apex > 4%') }
  it { is_expected.to route_command('apex >=4%') }
  it { is_expected.to route_command('apex >= 4%') }
  it { is_expected.to route_command('apexabvhigh') }
  it { is_expected.to route_command('apexabvlow') }

  before do
    mock = File.open('spec/fixtures/apex.html').read
    allow(RestClient).to receive(:get) { mock }
  end

  it 'shows the Apex taps' do
    send_command 'apex'
    expect(replies.last).to eq("taps: 1)  Aktien Helles Lager  2)  Armored Fist - Big,Black&amp;Hoppy  3)  Barrel Aged Old Thunderpussy  4)  Blind Pig - IPA  5)  Blue Bell Bitter   6)  Bone-A-Fide - Pale  7)  Breaking Bud - IPA  8)  Cheap, cold  9)  Cider- Huckleberry  10)  Cider- NeverGiveAnInch -Rosé   11)  Cuvée des Jacobins Rouge*  12)  Delilah Jones '15 - StrongRye  13)  Duet - IPA  14)  Golden - Herbs,Seeds,Spelt  15)  Grapefruit Radler  16)  Handtruck - Pale  17)  Head Shake - IIPA  18)  Hop Venom - IIPA  19)  Jahrhundert - Export Lager  20)  Kalifornia Kolsch  21)  Kristallweissbier  22)  Le Terroir*  23)  Lupulin River - IPA  24)  Maisel's Weisse - Hefeweizen   25)  Nitro- Adam -Drinking Tobacco  26)  Nitro- Aphrodisiaque - Stout   27)  Nitro- Old Rasputin - RIS  28)  Nitro- Red Seal - Red  29)  Nitro- Shake - Choco Porter  30)  Nitro- Stout  31)  Notorious - IIIPA  32)  Off Leash - NW Session Ale  33)  Old Crustacean '12-Barleywine  34)  Pallet Jack - IPA  35)  Phantasmagoria - IPA  36)  Pilsner  37)  Pliny The Elder  38)  Prairie-Vous Francais - Saison  <div class=\"btn btn-danger btn-mini\">\n<i class=\"icon-star icon-white\"></i> Just Tapped<i class=\"icon-star icon-white\"></i>\n</div>  39)  Proving Ground - IPA  40)  Prowell Springs - Pilsner  41)  Saison  42)  Saison de Lily  43)  Sho' Nuff - Belgian Pale  44)  Simple Life - Lacto Saison*  45)  Stout of Circumstance  46)  Sump - Imp Coffee Stout  47)  Tex Arcana - Stout  48)  Tripel Karmeliet  49)  Vivid - IIPA  50)  WFO - IPA")
  end

  it 'displays details for tap 4' do
    send_command 'taps 4'
    expect(replies.last).to eq('Bailey\'s tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining')
  end

  it 'doesn\'t explode on 1' do
    send_command 'taps 1'
    expect(replies.count).to eq(1)
    expect(replies.last).to eq('Bailey\'s tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining')
  end

  it 'gets nitro' do
    send_command 'taps nitro'
    expect(replies.last).to eq('Bailey\'s tap 6) (Nitro) Backwoods Winchester Brown - Brown Ale 6.2%, 10oz - $3 | 20oz - $5, 98% remaining')
  end

  it 'gets cask' do
    send_command 'taps cask'
    expect(replies.last).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
  end

  it 'searches for ipa' do
    send_command 'taps ipa'
    expect(replies.last).to eq("Bailey's tap 24) Oakshire Perfect Storm - Imperial IPA 9.0%, 10oz - $4 | 20oz - $6 | 32oz Crowler - $10, 61% remaining")
  end

  it 'searches for brown' do
    send_command 'taps brown'
    expect(replies.last).to eq("Bailey's tap 22) GoodLife 29er - India Brown Ale 6.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 37% remaining")
  end

  it 'searches for abv >9%' do
    send_command 'taps >9%'
    expect(replies.count).to eq(4)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for abv > 9%' do
    send_command 'taps > 9%'
    expect(replies.count).to eq(4)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for abv >= 9%' do
    send_command 'taps >= 9%'
    expect(replies.count).to eq(5)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
    expect(replies.last).to eq("Bailey's tap 24) Oakshire Perfect Storm - Imperial IPA 9.0%, 10oz - $4 | 20oz - $6 | 32oz Crowler - $10, 61% remaining")
  end

  it 'searches for abv <4.1%' do
    send_command 'taps <4.1%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for abv < 4.1%' do
    send_command 'taps < 4.1%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for abv <= 4%' do
    send_command 'taps <= 4%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for prices >$6' do
    send_command 'taps >$6'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
  end

  it 'searches for prices >=$6' do
    send_command 'taps >=$6'
    expect(replies.count).to eq(4)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
    expect(replies[2]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[3]).to eq("Bailey's tap 24) Oakshire Perfect Storm - Imperial IPA 9.0%, 10oz - $4 | 20oz - $6 | 32oz Crowler - $10, 61% remaining")
  end

  it 'searches for prices > $6' do
    send_command 'taps > $6'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
  end

  it 'searches for prices <$4.1' do
    send_command 'taps <$4.1'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for prices < $4.01' do
    send_command 'taps < $4.01'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for prices <= $4.00' do
    send_command 'taps <= $4.00'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'runs a random beer through' do
    send_command 'taps roulette'
    expect(replies.count).to eq(1)
    expect(replies.last).to include("Bailey's tap")
  end

  it 'runs a random beer through' do
    send_command 'taps random'
    expect(replies.count).to eq(1)
    expect(replies.last).to include("Bailey's tap")
  end

  it 'searches with a space' do
    send_command 'taps zeus juice'
    expect(replies.last).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
  end

  it 'displays low taps' do
    send_command 'tapslow'
    expect(replies.last).to eq("Bailey's tap 25) Green Flash Passion Fruit Kicker - Wheat Ale w/ Passion Fruit 5.5%, 10oz - $3 | 20oz - $5, <= 1% remaining")
  end

  it 'displays low abv' do
    send_command 'tapsabvhigh'
    expect(replies.last).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'displays high abv' do
    send_command 'tapsabvlow'
    expect(replies.last).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
  end
end
