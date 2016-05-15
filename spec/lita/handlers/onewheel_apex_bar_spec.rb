require 'spec_helper'

describe Lita::Handlers::OnewheelApexBar, lita_handler: true do
  it { is_expected.to route_command('apex') }
  it { is_expected.to route_command('apex 4') }
  it { is_expected.to route_command('apex nitro') }
  it { is_expected.to route_command('apex CASK') }
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
    expect(replies.last).to eq("taps: 1) Bayreuther Aktien Helles Lager  2) Boneyard Armored Fist - Big,Black&Hoppy  3) Magnolia Barrel Aged Old Thunderpussy  4) Russian River Blind Pig - IPA  5) Magnolia Blue Bell Bitter   6) Boneyard Bone-A-Fide - Pale  7) Knee Deep Breaking Bud - IPA  8) Hamm's Cheap, cold  9) Two Rivers Cider- Huckleberry  10) Cider Riot! Cider- NeverGiveAnInch -Rosé   11) Bockor Cuvée des Jacobins Rouge*  12) Magnolia Delilah Jones '15 - StrongRye  13) Alpine Duet - IPA  14) NewBelg&amp;HofTenDormaal Golden - Herbs,Seeds,Spelt  15) Stiegl Grapefruit Radler  16) Barley Brown's Handtruck - Pale  17) Barley Brown's Head Shake - IIPA  18) Boneyard Hop Venom - IIPA  19) Ayinger Jahrhundert - Export Lager  20) Magnolia Kalifornia Kolsch  21) Weihenstephan Kristallweissbier  22) New Belgium Le Terroir*  23) Knee Deep Lupulin River - IPA  24) Gebruder Maisel Maisel's Weisse - Hefeweizen   25) Hair of the Dog Nitro- Adam -Drinking Tobacco  26) Dieu du Ciel! Nitro- Aphrodisiaque - Stout   27) North Coast Nitro- Old Rasputin - RIS  28) North Coast Nitro- Red Seal - Red  29) Boulder Nitro- Shake - Choco Porter  30) Guinness Nitro- Stout  31) Boneyard Notorious - IIIPA  32) Crux Off Leash - NW Session Ale  33) Rogue Old Crustacean '12-Barleywine  34) Barley Brown's Pallet Jack - IPA  35) Prairie Phantasmagoria - IPA  36) Radeberger Pilsner  37) Russian River Pliny The Elder  38) Prairie Prairie-Vous Francais - Saison   Just Tapped  39) Magnolia Proving Ground - IPA  40) Crux Prowell Springs - Pilsner  41) Dupont Saison  42) Magnolia Saison de Lily  43) Against the Grain Sho' Nuff - Belgian Pale  44) To Øl Simple Life - Lacto Saison*  45) Magnolia Stout of Circumstance  46) Perennial  Sump - Imp Coffee Stout  47) Against the Grain Tex Arcana - Stout  48) Bosteels Tripel Karmeliet  49) Gigantic Vivid - IIPA  50) Barley Brown's WFO - IPA")
  end

  it 'displays details for tap 4' do
    send_command 'apex 4'
    expect(replies.last).to eq('Apex tap 4) Blind Pig - IPA 6.1%')
  end

  it 'doesn\'t explode on 1' do
    send_command 'apex 1'
    expect(replies.count).to eq(1)
    expect(replies.last).to eq('Apex tap 1) Aktien Helles Lager 5.3%')
  end

  it 'gets nitro' do
    send_command 'apex nitro'
    expect(replies.last).to eq('Apex tap 30) Nitro- Stout 4.1%')
  end

  it 'searches for ipa' do
    send_command 'apex ipa'
    expect(replies.last).to eq('Apex tap 50) WFO - IPA 7.5%')
  end

  # it 'searches for brown' do
  #   send_command 'apex brown'
  #   expect(replies.last).to eq("Bailey's tap 22) GoodLife 29er - India Brown Ale 6.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 37% remaining")
  # end

  it 'searches for abv >9%' do
    send_command 'apex >9%'
    expect(replies.count).to eq(8)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for abv > 9%' do
    send_command 'apex > 9%'
    expect(replies.count).to eq(4)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for abv >= 9%' do
    send_command 'apex >= 9%'
    expect(replies.count).to eq(5)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[2]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[3]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
    expect(replies.last).to eq("Bailey's tap 24) Oakshire Perfect Storm - Imperial IPA 9.0%, 10oz - $4 | 20oz - $6 | 32oz Crowler - $10, 61% remaining")
  end

  it 'searches for abv <4.1%' do
    send_command 'apex <4.1%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for abv < 4.1%' do
    send_command 'apex < 4.1%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for abv <= 4%' do
    send_command 'apex <= 4%'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
    expect(replies.last).to eq("Bailey's tap 11) Lagunitas Copper Fusion Ale - Copper Ale 4.0%, 10oz - $3 | 20oz - $5 | 32oz Crowler - $8, 19% remaining")
  end

  it 'searches for prices >$6' do
    send_command 'apex >$6'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
  end

  it 'searches for prices >=$6' do
    send_command 'apex >=$6'
    expect(replies.count).to eq(4)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
    expect(replies[2]).to eq("Bailey's tap 9) Hopworks Noggin’ Floggin’ - Barleywine 11.0%, 4oz - $3 | 12oz - $6 | 32oz Crowler - $13, 34% remaining")
    expect(replies[3]).to eq("Bailey's tap 24) Oakshire Perfect Storm - Imperial IPA 9.0%, 10oz - $4 | 20oz - $6 | 32oz Crowler - $10, 61% remaining")
  end

  it 'searches for prices > $6' do
    send_command 'apex > $6'
    expect(replies.count).to eq(2)
    expect(replies[0]).to eq("Bailey's tap 1) Cider Riot! Plastic Paddy - Apple Cider w/ Irish tea 6.0%, 10oz - $4 | 20oz - $7 | 32oz Crowler - $10, 48% remaining")
    expect(replies[1]).to eq("Bailey's tap 4) Wild Ride Solidarity - Abbey Dubbel – Barrel Aged (Pinot Noir) 8.2%, 4oz - $4 | 12oz - $7, 26% remaining")
  end

  it 'searches for prices <$4.1' do
    send_command 'apex <$4.1'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for prices < $4.01' do
    send_command 'apex < $4.01'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'searches for prices <= $4.00' do
    send_command 'apex <= $4.00'
    expect(replies.count).to eq(3)
    expect(replies[0]).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
    expect(replies[1]).to eq("Bailey's tap 18) Knee Deep Hop Surplus - Triple IPA 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 25% remaining")
    expect(replies[2]).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'runs a random beer through' do
    send_command 'apex roulette'
    expect(replies.count).to eq(1)
    expect(replies.last).to include("Bailey's tap")
  end

  it 'runs a random beer through' do
    send_command 'apex random'
    expect(replies.count).to eq(1)
    expect(replies.last).to include("Bailey's tap")
  end

  it 'searches with a space' do
    send_command 'apex zeus juice'
    expect(replies.last).to eq("Bailey's tap 8) Fat Head’s Zeus Juice - Belgian Strong Blonde 10.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $9, 44% remaining")
  end

  it 'displays low abv' do
    send_command 'apexabvhigh'
    expect(replies.last).to eq("Bailey's tap 20) Knee Deep Dark Horse - Imperial Stout 12.0%, 4oz - $2 | 12oz - $4 | 32oz Crowler - $10, 39% remaining")
  end

  it 'displays high abv' do
    send_command 'apexabvlow'
    expect(replies.last).to eq("Bailey's tap 3) (Cask) Machine House Crystal Maze - ESB 4.0%, 10oz - $3 | 20oz - $5, 57% remaining")
  end
end
