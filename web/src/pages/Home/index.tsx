import React from 'react'
import { Link } from 'react-router-dom'
import {
  HomeHeaderPanel,
  HomeHeader,
  LogoPanel,
  SearchPanel,
  BlockPanel,
  ContentTitle,
  ContentTable,
  TableTitleRow,
  TableContentRow,
  TableMinerContentPanel,
  TableMorePanel,
} from './index.css'
import { parseDate } from '../../utils/date'
import Page from '../../components/Page'
import Header from '../../components/Header'
import Content from '../../components/Content'
import Footer from '../../components/Footer'
import HomeLogo from '../../asserts/logo_home.png'
import SearchLogo from '../../asserts/search.png'
import BlockHeightIcon from '../../asserts/block_height.png'
import TransactionIcon from '../../asserts/transactions.png'
import CellConsumedIcon from '../../asserts/cell_consumed.png'
import MinerIcon from '../../asserts/miner.png'
import TimestampIcon from '../../asserts/timestamp.png'
import MoreLeftIcon from '../../asserts/more_left.png'
import MoreRightIcon from '../../asserts/more_right.png'
import BlocksData from './mock'

const TableTitleItem = ({ image, title }: { image: string; title: string }) => {
  return (
    <div>
      <div>
        <img src={image} alt={title} />
        <div>{title}</div>
      </div>
    </div>
  )
}

const TableContentItem = ({ color, content }: { color: string; content: string }) => {
  return (
    <div
      style={{
        color,
        height: (78 * window.innerWidth) / 1920,
      }}
    >
      {content}
    </div>
  )
}

const TableMinerContentItem = ({ color, content }: { color: string; content: string }) => {
  return (
    <TableMinerContentPanel color={color}>
      <Link className="table__miner__content" to={`/address/${content}`}>
        {content}
      </Link>
    </TableMinerContentPanel>
  )
}

export default () => {
  const [clickableColor, normalColor] = ['#4bbc8e', '888888']
  return (
    <Page>
      <Header search={false} />
      <Content>
        <HomeHeaderPanel width={window.innerWidth}>
          <HomeHeader>
            <LogoPanel>
              <img src={HomeLogo} alt="home logo" />
              <div>CKB Testnet Explorer</div>
            </LogoPanel>
            <SearchPanel width={window.innerWidth}>
              <input placeholder="Block Heigth / Block Hash / TxHash / Address" />
              <img src={SearchLogo} alt="search logo" />
            </SearchPanel>
          </HomeHeader>
        </HomeHeaderPanel>

        <BlockPanel width={window.innerWidth}>
          <ContentTitle>
            <div>Latest Blocks</div>
            <span />
          </ContentTitle>

          <ContentTable>
            <div>
              <TableTitleRow width={window.innerWidth}>
                <TableTitleItem image={BlockHeightIcon} title="Height" />
                <TableTitleItem image={TransactionIcon} title="Transactions" />
                <TableTitleItem image={CellConsumedIcon} title="Cell Consumed(B)" />
                <TableTitleItem image={MinerIcon} title="Miner" />
                <TableTitleItem image={TimestampIcon} title="Time" />
              </TableTitleRow>
              {BlocksData.data.map((data: any) => {
                return (
                  <TableContentRow key={data.block_hash}>
                    <TableContentItem color={clickableColor} content={data.number} />
                    <TableContentItem color={normalColor} content={data.transactions_count} />
                    <TableContentItem color={normalColor} content={data.cell_consumed} />
                    <TableMinerContentItem color={clickableColor} content={data.miner_hash} />
                    <TableContentItem color={normalColor} content={parseDate(data.timestamp)} />
                  </TableContentRow>
                )
              })}
            </div>
          </ContentTable>
          <TableMorePanel>
            <div>
              <img src={MoreLeftIcon} alt="more left" />
              <div>
                <Link className="table__more" to="block/list">
                  More
                </Link>
              </div>
              <img src={MoreRightIcon} alt="more right" />
            </div>
          </TableMorePanel>
        </BlockPanel>
      </Content>
      <Footer />
    </Page>
  )
}
